-- |
import XMonad
import XMonad.Config
import XMonad.Prompt
import XMonad.Util.EZConfig
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.DynamicWorkspaces
import qualified XMonad.StackSet as W
import qualified Data.List as L
-- polybar
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D

myScreenCount = 2

main :: IO ()
main = do
  dbus <- mkDbusClient
  xmonad $ ewmh $ defaultConfig
    { terminal = "alacritty"
    , modMask = mod4Mask
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
    , handleEventHook = myHandleEventHook
    , workspaces = [show i | i <- [1..9]]
    , logHook = myPolybarLogHook dbus
    }
    `additionalKeys` myKeybindings

myLayoutHook =
  avoidStruts (layoutHook defaultConfig)

myManageHook =
  manageDocks
  <+> composeAll
    [ resource =? ".arandr-wrapped" --> doFloat
    , resource =? ".blueman-manager-wrapped" --> doFloat
    , resource =? "pavucontrol" --> doFloat
    ]

myHandleEventHook =
  docksEventHook

myKeybindings =
  [ ((mod4Mask, xK_p), spawn "rofi -show combi -combi-modi window,drun,run")
  , ((mod4Mask, xK_r), renameWorkspace myXPConfig)
  ]
  ++
  [ ((modm, key), c horizontalScreenOrderer f)
  | (modm, f) <- [(mod4Mask, W.view) ,(mod4Mask .|. shiftMask, W.shift)]
  , (key, c) <- [(xK_w, onPrevNeighbour), (xK_e, onNextNeighbour)]
  ]
  ++
  [ ((modm, key), action i)
  | (modm, action) <- [(mod4Mask, viewWorkspaceByPrefix . show), (mod4Mask .|. shiftMask, shiftToWorkspaceByPrefix . show)]
  , (key, i) <- zip [xK_1..xK_9] [1..9]
  ]

myXPConfig = defaultXPConfig

viewWorkspaceByPrefix prefix = windows $ \s ->
  case findTagByPrefix prefix s of
    Just i -> W.view i s
    _ -> s

shiftToWorkspaceByPrefix prefix = windows $ \s ->
  case findTagByPrefix prefix s of
    Just i -> W.shift i s
    _ -> s

findTagByPrefix prefix s =
  L.find (prefix `L.isPrefixOf`) $ map W.tag $ W.workspaces s

-- Below was stolen from https://github.com/gvolpe/nix-config/blob/master/home/programs/xmonad/config.hs

------------------------------------------------------------------------
-- Polybar settings (needs DBus client).
--
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = dynamicLogWithPP (polybarHook dbus)
