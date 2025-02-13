{
  home-manager.sharedModules = [
    (
      {pkgs, ...}: let
        extensions = {
          "trackmenot@mrl.nyu.edu" = "https://addons.mozilla.org/firefox/downloads/latest/trackmenot/latest.xpi";
          "{74145f27-f039-47ce-a470-a662b129930a}" = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "jid1-BoFifL9Vbdl2zQ@jetpack" = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
          "adnauseam@rednoise.org" = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
          "{278b0ae0-da9d-4cc6-be81-5aa7f3202672}" = "https://addons.mozilla.org/firefox/downloads/latest/re-enable-right-click/latest.xpi";
          "sponsorBlocker@ajay.app" = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          "extension@tabliss.io" = "https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi";
          "vimium-c@gdh1995.cn" = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
          "{34daeb50-c2d2-4f14-886a-7160b24d66a4}" = "https://addons.mozilla.org/firefox/downloads/latest/youtube-shorts-block/latest.xpi";
        };
      in {
        config = {
          home.sessionVariables = {
            MOZ_ENABLE_WAYLAND = 1;
            MOZ_USE_XINPUT2 = 1;
          };
          programs.firefox = {
            enable = true;
            package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
              extraPolicies = {
                CaptivePortal = false;
                DisableFirefoxStudies = true;
                DisablePocket = true;
                DisableTelemetry = true;
                DisableFirefoxAccounts = true;
                NoDefaultBookmarks = true;
                OfferToSaveLoginsDefault = true;
                FirefoxHome = {
                  Search = true;
                  Pocket = false;
                  Snippets = false;
                  TopSites = false;
                  Highlights = false;
                };
                UserMessaging = {
                  ExtensionRecommendations = false;
                  SkipOnboarding = true;
                };
                ExtensionSettings =
                  (builtins.mapAttrs
                    (k: v: {
                      installation_mode = "normal_installed";
                      install_url = v;
                    })
                    extensions)
                  // {
                    "*" = {adminSettings = {firstInstall = false;};};
                  };
              };
            };
            profiles = {
              sargo = {
                id = 0;
                name = "sargo";
                search = {
                  force = true;
                  default = "Brave";
                  engines = {
                    Brave = {
                      urls = [
                        {
                          template = "https://search.brave.com/search";
                          params = [
                            {
                              name = "q";
                              value = "{searchTerms}";
                            }
                          ];
                        }
                      ];
                      iconUpdateURL = "https://cdn.search.brave.com/serp/v1/static/brand/16c26cd189da3f0f7ba4e55a584ddde6a7853c9cc340ff9f381afc6cb18e9a1e-favicon-32x32.png";
                      updateInterval = 24 * 60 * 60 * 1000;
                    };
                    "Nix Packages" = {
                      urls = [
                        {
                          template = "https://search.nixos.org/packages";
                          params = [
                            {
                              name = "type";
                              value = "packages";
                            }
                            {
                              name = "query";
                              value = "{searchTerms}";
                            }
                          ];
                        }
                      ];
                      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                      definedAliases = ["@np"];
                    };
                    "NixOS Wiki" = {
                      urls = [
                        {
                          template = "https://nixos.wiki/index.php?search={searchTerms}";
                        }
                      ];
                      iconUpdateURL = "https://nixos.wiki/favicon.png";
                      updateInterval = 24 * 60 * 60 * 1000;
                      definedAliases = ["@nw"];
                    };
                    "Home manager option search" = {
                      urls = [
                        {
                          template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
                        }
                      ];
                      iconUpdateURL = "https://mipmip.github.io/home-manager-option-search/images/favicon.png";
                      updateInterval = 24 * 60 * 60 * 1000;
                      definedAliases = ["@hm"];
                    };
                    "Khan academy" = {
                      urls = [
                        {
                          template = "https://www.khanacademy.org/search?search_again=1&page_search_query={searchTerms}";
                        }
                      ];
                      iconUpdateURL = "https://cdn.kastatic.org/images/favicon.ico?logo";
                      updateInterval = 24 * 60 * 60 * 1000;
                      definedAliases = ["@ka" "@k"];
                    };
                    "Lib.rs" = {
                      urls = [{template = "https://lib.rs/search?q={searchTerms}";}];
                      iconUpdateURL = "https://lib.rs/favicon.png";
                      updateInterval = 24 * 60 * 60 * 1000;
                      definedAliases = ["@lb" "@rs"];
                    };
                    "Wikipedia (en)".metaData.alias = "@wiki";
                    "Google".metaData.hidden = true;
                    "Amazon.com".metaData.hidden = true;
                    "Bing".metaData.hidden = true;
                    "eBay".metaData.hidden = true;
                  };
                };

                settings = {
                  "general.smoothScroll" = true;

                  ### disable crash-recover after 'ungraceful' process termination
                  "browser.sessionstore.resume_from_crash" = false;

                  ### disable safe-mode after 'ungraceful' process termination
                  "browser.sessionstore.max_resumed_crashes" = 0;
                  "toolkit.startup.max_resumed_crashes" = -1;
                  "browser.sessionstore.restore_on_demand" = false;
                  "browser.sessionstore.restore_tabs_lazily" = false;

                  ### set download folder (not set by firefox)
                  "browser.download.dir" = "str(Path.home())";

                  ### enable compatibility
                  "devtools.chrome.enabled" = true;

                  ### don't open dialog to accept connections from client
                  "devtools.debugger.prompt-connection" = false;

                  ### enable remote debugging
                  "devtools.debugger.remote-enabled" = true;

                  ### allow tab isolation (for e.g. separate cookie-jar)
                  "privacy.userContext.enabled" = true;

                  ### misc
                  "devtools.cache.disabled" = true;
                  "browser.aboutConfig.showWarning" = false;
                  "browser.tabs.warnOnClose" = false;
                  "browser.tabs.warnOnCloseOtherTabs" = false;
                  "browser.shell.skipDefaultBrowserCheckOnFirstRun" = true;
                  "pdfjs.firstRun" = true;
                  "doh-rollout.doneFirstRun" = true;
                  "browser.startup.firstrunSkipsHomepage" = true;
                  "browser.tabs.warnOnOpen" = false;
                  "browser.warnOnQuit" = false;
                  "toolkit.telemetry.reportingpolicy.firstRun" = false;
                  "trailhead.firstrun.didSeeAboutWelcome" = true;

                  "extensions.autoDisableScopes" = 0;
                  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                  "full-screen-api.ignore-widgets" = true;
                  "media.ffmpeg.vaapi.enabled" = true;
                  "media.rdd-vpx.enabled" = true;
                  /*
                    You may copy+paste this file and use it as it is.
                  *
                  * If you make changes to your about:config while the program is running, the
                  * changes will be overwritten by the user.js when the application restarts.
                  *
                  * To make lasting changes to preferences, you will have to edit the user.js.
                  */

                  /*
                    ***************************************************************************
                   * Betterfox                                                                *
                   * "Ad meliora"                                                             *
                   * version: 113                                                             *
                   * url: https://github.com/yokoffing/Betterfox                              *
                  ***************************************************************************
                  */

                  /*
                    ***************************************************************************
                   * SECTION: FASTFOX                                                         *
                  ***************************************************************************
                  */
                  "nglayout.initialpaint.delay" = 0;
                  "nglayout.initialpaint.delay_in_oopif" = 0;
                  "content.notify.interval" = 100000;
                  "browser.startup.preXulSkeletonUI" = false;

                  /*
                  * EXPERIMENTAL **
                  */
                  "layout.css.grid-template-masonry-value.enabled" = true;
                  "layout.css.animation-composition.enabled" = true;
                  "dom.enable_web_task_scheduling" = true;

                  /*
                  * GFX **
                  */
                  "gfx.webrender.all" = true;
                  "gfx.webrender.precache-shaders" = true;
                  "gfx.webrender.compositor" = true;
                  "layers.gpu-process.enabled" = true;
                  "media.hardware-video-decoding.enabled" = true;
                  "gfx.canvas.accelerated" = true;
                  "gfx.canvas.accelerated.cache-items" = 32768;
                  "gfx.canvas.accelerated.cache-size" = 4096;
                  "gfx.content.skia-font-cache-size" = 80;
                  "image.cache.size" = 10485760;
                  "image.mem.decode_bytes_at_a_time" = 131072;
                  "image.mem.shared.unmap.min_expiration_ms" = 120000;
                  "media.memory_cache_max_size" = 1048576;
                  "media.memory_caches_combined_limit_kb" = 2560000;
                  "media.cache_readahead_limit" = 9000;
                  "media.cache_resume_threshold" = 6000;

                  /*
                  * BROWSER CACHE **
                  */
                  "browser.cache.memory.max_entry_size" = 153600;

                  /*
                  * NETWORK **
                  */
                  "network.buffer.cache.size" = 262144;
                  "network.buffer.cache.count" = 128;
                  "network.http.max-connections" = 1800;
                  "network.http.max-persistent-connections-per-server" = 10;
                  "network.ssl_tokens_cache_capacity" = 32768;

                  /*
                    ***************************************************************************
                   * SECTION: SECUREFOX                                                       *
                  ***************************************************************************
                  */
                  /*
                  * TRACKING PROTECTION **
                  */
                  "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
                  "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
                  "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";
                  "browser.uitour.enabled" = false;
                  "privacy.globalprivacycontrol.enabled" = true;
                  "privacy.globalprivacycontrol.functionality.enabled" = true;

                  /*
                  * OCSP & CERTS / HPKP **
                  */
                  "security.OCSP.enabled" = 0;
                  "security.remote_settings.crlite_filters.enabled" = true;
                  "security.pki.crlite_mode" = 2;
                  "security.cert_pinning.enforcement_level" = 2;

                  /*
                  * SSL / TLS **
                  */
                  "security.ssl.treat_unsafe_negotiation_as_broken" = true;
                  "browser.xul.error_pages.expert_bad_cert" = true;
                  "security.tls.enable_0rtt_data" = false;

                  /*
                  * DISK AVOIDANCE **
                  */
                  "browser.cache.disk.enable" = false;
                  "browser.privatebrowsing.forceMediaMemoryCache" = true;
                  "browser.sessionstore.privacy_level" = 2;

                  /*
                  * SHUTDOWN & SANITIZING **
                  */
                  "privacy.history.custom" = true;

                  # // /** SPECULATIVE CONNECTIONS ***/
                  # // "network.http.speculative-parallel-limit" = 0;
                  # // "network.dns.disablePrefetch" = true;
                  # // "browser.urlbar.speculativeConnect.enabled" = false;
                  # // "browser.places.speculativeConnect.enabled" = false;
                  # // "network.prefetch-next" = false;
                  # // "network.predictor.enabled" = false;
                  # // "network.predictor.enable-prefetch" = false;

                  /*
                  * SEARCH / URL BAR **
                  */
                  "browser.search.separatePrivateDefault.ui.enabled" = true;
                  "browser.urlbar.update2.engineAliasRefresh" = true;
                  "browser.search.suggest.enabled" = false;
                  "browser.urlbar.suggest.quicksuggest.sponsored" = false;
                  "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
                  "security.insecure_connection_text.enabled" = true;
                  "security.insecure_connection_text.pbmode.enabled" = true;
                  "network.IDN_show_punycode" = true;

                  /*
                  * HTTPS-FIRST MODE **
                  */
                  "dom.security.https_first" = true;

                  /*
                  * PROXY / SOCKS / IPv6 **
                  */
                  "network.proxy.socks_remote_dns" = true;
                  "network.file.disable_unc_paths" = true;
                  "network.gio.supported-protocols" = "";

                  /*
                  * PASSWORDS AND AUTOFILL **
                  */
                  "signon.formlessCapture.enabled" = false;
                  "signon.privateBrowsingCapture.enabled" = false;
                  "signon.autofillForms" = false;
                  "signon.rememberSignons" = false;
                  "editor.truncate_user_pastes" = false;

                  /*
                  * ADDRESS + CREDIT CARD MANAGER **
                  */
                  "extensions.formautofill.addresses.enabled" = false;
                  "extensions.formautofill.creditCards.enabled" = false;
                  "extensions.formautofill.heuristics.enabled" = false;
                  "browser.formfill.enable" = false;

                  /*
                  * MIXED CONTENT + CROSS-SITE **
                  */
                  "network.auth.subresource-http-auth-allow" = 1;
                  "pdfjs.enableScripting" = false;
                  "extensions.postDownloadThirdPartyPrompt" = false;
                  "permissions.delegation.enabled" = false;

                  /*
                  * HEADERS / REFERERS **
                  */
                  "network.http.referer.XOriginTrimmingPolicy" = 2;

                  /*
                  * CONTAINERS **
                  */
                  "privacy.userContext.ui.enabled" = true;

                  /*
                  * WEBRTC **
                  */
                  "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
                  "media.peerconnection.ice.default_address_only" = true;

                  /*
                  * SAFE BROWSING **
                  */
                  "browser.safebrowsing.downloads.remote.enabled" = false;

                  /*
                  * MOZILLA **
                  */
                  "accessibility.force_disabled" = 1;
                  "identity.fxaccounts.enabled" = false;
                  "browser.tabs.firefox-view" = false;
                  "permissions.default.desktop-notification" = 2;
                  "permissions.default.geo" = 2;
                  "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
                  "geo.provider.ms-windows-location" = false; # WINDOWS
                  "geo.provider.use_corelocation" = false; # MAC
                  "geo.provider.use_gpsd" = false; # LINUX
                  "geo.provider.use_geoclue" = false; # LINUX
                  "permissions.manager.defaultsUrl" = "";
                  "webchannel.allowObject.urlWhitelist" = "";

                  /*
                  * TELEMETRY **
                  */
                  "toolkit.telemetry.unified" = false;
                  "toolkit.telemetry.enabled" = false;
                  "toolkit.telemetry.server" = "data:,";
                  "toolkit.telemetry.archive.enabled" = false;
                  "toolkit.telemetry.newProfilePing.enabled" = false;
                  "toolkit.telemetry.shutdownPingSender.enabled" = false;
                  "toolkit.telemetry.updatePing.enabled" = false;
                  "toolkit.telemetry.bhrPing.enabled" = false;
                  "toolkit.telemetry.firstShutdownPing.enabled" = false;
                  "toolkit.telemetry.coverage.opt-out" = true;
                  "toolkit.coverage.opt-out" = true;
                  "datareporting.healthreport.uploadEnabled" = false;
                  "datareporting.policy.dataSubmissionEnabled" = false;
                  "app.shield.optoutstudies.enabled" = false;
                  "browser.discovery.enabled" = false;
                  "breakpad.reportURL" = "";
                  "browser.tabs.crashReporting.sendReport" = false;
                  "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
                  "captivedetect.canonicalURL" = "";
                  "network.captive-portal-service.enabled" = false;
                  "network.connectivity-service.enabled" = false;
                  "default-browser-agent.enabled" = false;
                  "app.normandy.enabled" = false;
                  "app.normandy.api_url" = "";
                  "browser.ping-centre.telemetry" = false;
                  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                  "browser.newtabpage.activity-stream.telemetry" = false;

                  /*
                    ***************************************************************************
                   * SECTION: PESKYFOX                                                        *
                  ***************************************************************************
                  */
                  /*
                  * MOZILLA UI **
                  */
                  "layout.css.prefers-color-scheme.content-override" = 2;
                  "app.update.suppressPrompts" = true;
                  "browser.compactmode.show" = true;
                  "browser.privatebrowsing.vpnpromourl" = "";
                  "extensions.getAddons.showPane" = false;
                  "extensions.htmlaboutaddons.recommendations.enabled" = false;
                  "browser.shell.checkDefaultBrowser" = false;
                  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
                  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
                  "browser.preferences.moreFromMozilla" = false;
                  "browser.tabs.tabmanager.enabled" = false;
                  "browser.aboutwelcome.enabled" = false;
                  "findbar.highlightAll" = true;
                  "middlemouse.contentLoadURL" = false;
                  "browser.privatebrowsing.enable-new-indicator" = false;

                  /*
                  * FULLSCREEN **
                  */
                  "full-screen-api.transition-duration.enter" = "0 0";
                  "full-screen-api.transition-duration.leave" = "0 0";
                  "full-screen-api.warning.delay" = -1;
                  "full-screen-api.warning.timeout" = 0;

                  /*
                  * URL BAR **
                  */
                  "browser.urlbar.suggest.engines" = false;
                  "browser.urlbar.suggest.topsites" = false;
                  "browser.urlbar.suggest.calculator" = true;
                  "browser.urlbar.unitConversion.enabled" = true;

                  /*
                  * NEW TAB PAGE **
                  */
                  "browser.newtabpage.activity-stream.feeds.topsites" = false;
                  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

                  /*
                  ** POCKET **
                  */
                  "extensions.pocket.enabled" = false;

                  /*
                  * DOWNLOADS **
                  */
                  "browser.download.useDownloadDir" = false;
                  "browser.download.alwaysOpenPanel" = false;
                  "browser.download.manager.addToRecentDocs" = false;
                  "browser.download.always_ask_before_handling_new_types" = true;

                  /*
                  * PDF **
                  */
                  "browser.download.open_pdf_attachments_inline" = true;

                  /*
                  * TAB BEHAVIOR **
                  */
                  "browser.tabs.loadBookmarksInTabs" = true;
                  "browser.bookmarks.openInTabClosesMenu" = false;
                  "layout.css.has-selector.enabled" = true;

                  /*
                    ***************************************************************************
                   * SECTION: SMOOTHFOX                                                       *
                  ***************************************************************************
                  */
                  # // visit https://github.com/yokoffing/Betterfox/blob/master/Smoothfox.js
                  # // Enter your scrolling prefs below this line:
                  # "general.smoothScroll" =                       true; // DEFAULT
                  "mousewheel.default.delta_multiplier_y" = 275; # 250-400

                  /*
                    ***************************************************************************
                   * END: BETTERFOX                                                           *
                  ***************************************************************************
                  */

                  "mousewheel.min_line_scroll_amount" = 30;
                  "mousewheel.system_scroll_override_on_root_content.enabled" = true;
                  "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
                  "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
                  "toolkit.scrollbox.horizontalScrollDistance" = 6;
                  "toolkit.scrollbox.verticalScrollDistance" = 2;

                  "general.smoothScroll.lines.durationMaxMS" = 125;
                  "general.smoothScroll.lines.durationMinMS" = 125;
                  "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
                  "general.smoothScroll.mouseWheel.durationMinMS" = 100;
                  "general.smoothScroll.msdPhysics.enabled" = true;
                  "general.smoothScroll.other.durationMaxMS" = 125;
                  "general.smoothScroll.other.durationMinMS" = 125;
                  "general.smoothScroll.pages.durationMaxMS" = 125;
                  "general.smoothScroll.pages.durationMinMS" = 125;

                  "svg.context-properties.content.enabled" = true;
                  "browser.toolbars.bookmarks.visibility" = "never";
                  "layers.acceleration.force-enabled" = true;
                  "gfx.webrender.enabled" = true;
                  "layout.css.backdrop-filter.enabled" = true;
                };
                extraConfig =
                  # js
                  ''

                  '';
              };
            };
          };
        };
      }
    )
  ];
}
