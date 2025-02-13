import asyncio
import os
import psutil
import threading
from typing import Optional
from geckordp.actors.descriptors.tab import TabActor
from geckordp.actors.events import Events
from geckordp.actors.root import RootActor
from geckordp.actors.targets.window_global import WindowGlobalActor
from geckordp.actors.web_console import WebConsoleActor
# from geckordp.firefox import Firefox
# from geckordp.profile import ProfileManager
from geckordp.rdp_client import RDPClient

class FFTab:
    def __init__(self,client,id):
        self.__actor = TabActor(client, id)
        self.__client = client
        # self.watcher_actor_id = self.actor.get_watcher()["actor"]
        # self.watcher_actor = WatcherActor(client, self.watcher_actor_id)
        # self.watcher_actor.watch_resources( [ Resources.DOCUMENT_EVENT, Resources.NETWORK_EVENT] )
        # def call_back(*args, **kwargs):
        #     print(*args, *(f'{key}:{value}' for key,value in kwargs.items()))
        # self.client.add_event_listener(self.watcher_actor_id, Events.Watcher.RESOURCES_AVAILABLE_ARRAY, print)
        # self.client.add_event_listener(self.actor.get_target()['actor'], Events.Browser.TAB_NAVIGATED, print)
        # self.client.add_event_listener(self.actor.get_target()['actor'], Events.Browser.FRAME_UPDATE, print)
        # self.client.add_event_listener(self.actor.get_target()['actor'], Events.Browser.TAB_DETACHED, print)

        self.__ca = self.__console_actor()
        self.__eval_id = 0
        self.__eval_results = {}
        
    def __window_actor(self) -> WindowGlobalActor:
        return WindowGlobalActor(self.__client, self.__actor.get_target()['actor'])

    def __console_actor(self) -> WebConsoleActor:
        return WebConsoleActor(self.__client, self.__actor.get_target()['consoleActor'])

    async def get_url(self):
        return await self.exec_js('document.URL')
    
    async def navigate(self, url: str, wait=True):
        self.__window_actor().navigate_to(url)
        if wait:
            while url != await self.get_url():
                await asyncio.sleep(0.2)

    async def __on_eval_result(self, data: dict):
        print(data)
        if data['hasException']:
            print(data['exception'])
            return None

        result = data['result']['preview']['items']
        if (entry := self.__eval_results.pop(result[0])) is not None:
            waker, val = entry
            val['value'] = result[1]
            print(f"Waking {result[0]}")
            waker.set()

    def __get_console(self):
        current_tab_console_id = self.__actor.get_target()['consoleActor']
        if current_tab_console_id != self.__ca.actor_id:
            self.__client.remove_event_listeners_by_id(self.__ca.actor_id)
            self.__ca.actor_id = current_tab_console_id
            self.__client.add_event_listener(current_tab_console_id, Events.WebConsole.EVALUATION_RESULT, self.__on_eval_result)

    
    async def exec_js(self, js: str, *args, **kwargs):
        def inner():
            event = threading.Event()
            result = {'value': None}
            self.__eval_id += 1
            self.__eval_results[self.__eval_id] = (event,result)

            self.__get_console() 
            self.__ca.evaluate_js_async(f'a=[{str(self.__eval_id)},({js})]', *args, **kwargs)

            print(f"Waiting for wake up {self.__eval_id}")
            event.wait()
            print("returing: ", result['value'])
            return result['value']

        return await asyncio.threads.to_thread(inner)


    async def wait_loaded(self, timeout=None):
        # async def inner():
        while await self.exec_js('document.readyState') != 'complete':
            await asyncio.sleep(0.2)


        # return await asyncio.complete(inner(), timeout)
    
    async def focus(self):
        def inner():
            self.__window_actor().focus()
        await asyncio.get_running_loop().run_in_executor(None, inner)

        

class FFConection:
    def __init__(self, port):
        self.client = RDPClient()
        self.root = RootActor(self.client)
        # threading.Thread(target=lambda: ).run()
        self.client.connect("localhost", port)

    async def get_tab_by_url(self, url) -> Optional[FFTab]:
        def blocking():
            tab = {tab['url']: tab  for tab in self.root.list_tabs()}.get(url)
            if tab is None:
                return None
            return FFTab(self.client, tab['actor'])
        return await asyncio.get_running_loop().run_in_executor(None, blocking)

    async def get_tabs(self):
        def blocking():
            return self.root.list_tabs()
        return await asyncio.get_running_loop().run_in_executor(None, blocking)


async def search_tabs(con):
    tabs = {f'T: {tab["title"]} U: {tab["url"]}': tab['actor'] for tab in await con.get_tabs()}
    proc = await asyncio.subprocess.create_subprocess_exec(
        "sk", stdout=asyncio.subprocess.PIPE, stdin=asyncio.subprocess.PIPE
    )

    proc.stdin.write('\n'.join(tabs.keys()).encode())
    # output = stdout.decode()[:-1]

    # tab = FFTab(con.client, tabs[output])
    (stdout,stderr) = await proc.communicate()
    # await tab.focus()
    

async def main():
    con = FFConection(6001)

    # while True:
    await search_tabs(con)
    
        
    
    #
    #
    #
    # tab = await con.get_tab_by_url('https://example.com/')
    # await tab.focus()
    # await tab.navigate('https://evision.otago.ac.nz/sitsvision/wrd/siw_lgn')
    # print("Loaded")
    # await tab.exec_js(
    #     'alert("Hi")'
    # )
    #
    #]

    # await open_evision(con, False)

def firefox(urls = []):
    params = ['firefox' ]
    if '.firefox-wrapped' not in (p.name() for p in psutil.process_iter()):
        params.extend(['-no-default-browser-check', '-P', 'sargo', '--start-debugger-server', '6001'])        
    params.extend(urls)
    return params

async def evision_login(tab: FFTab, username: str, password: str):
    print("Logging in")
    if 'siw_portal' not in await tab.get_url():
        await tab.navigate('https://evision.otago.ac.nz/sitsvision/wrd/siw_lgn')
        await tab.exec_js(f'document.getElementById("MUA_CODE.DUMMY.MENSYS").value = "{username}"'),
        await tab.exec_js(f'document.getElementById("PASSWORD.DUMMY.MENSYS").value = "{password}"')
        await tab.exec_js('document.getElementById("siwLgnLogIn").click()')

    
async def open_evision(connection: FFConection, new_window: bool):
    async def get_tabs():
        return [tab['actor'] for tab in await connection.get_tabs() if 'evision.otago.ac.nz' in tab['url']]
    url = 'https://evision.otago.ac.nz/sitsvision/wrd/siw_lgn'
    spawned = False
    while True:
        matches = await get_tabs()
        if len(matches) > 0:
            tab = FFTab(connection.client, matches[0]) 
            break
        if not spawned:
            spawned = True
            params = [url]
            if new_window:
                params.append('-new-window')
            args = firefox(params)
            print('spawning: ', args)
            prog = args.pop(0)
            os.spawnlp(os.P_NOWAIT, prog, prog, *args)
        await asyncio.sleep(0.2)

    await asyncio.gather(*[
             evision_login(tab, 'sarol263', 'my_password'),
             tab.focus()
                         ])

if __name__ == '__main__':
    asyncio.run(main())
