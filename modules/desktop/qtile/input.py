import asyncio
import sys


async def main():

    cmd = 'libinput-debug-event /dev/input/event8'
    
    proc = await asyncio.create_subprocess_exec(
        '/nix/store/iaikcwy26q2qsq33x3lpxxsframz2spq-libinput-1.26.2-bin/libexec/libinput/libinput-debug-events', '/dev/input/event8', 
        stdout=asyncio.subprocess.PIPE)

    while True:
        line = await proc.stdout.readline()
        update = line.decode('ascii').rstrip().split(' ')
        kind = update[4]
        if kind == 'GESTURE_PINCH_UPDATE':
            
            print(update[update.index('@') - 1])


if __name__ == '__main__':
    asyncio.run(main())
    
