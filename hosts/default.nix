with builtins; let
  paths = [./basato ./wojak];
  last = list: elemAt list (length list - 1);
in
  foldl'
  (acc: x:
    acc
    // {
      "${head (split "\\." (last (split "/" (toString x))))}" = {
        modules = [x {services.swapspace.enable = true;}];
      };
    })
  {}
  paths
