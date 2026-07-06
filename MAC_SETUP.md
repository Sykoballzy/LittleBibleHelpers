# Mac session crib sheet (MacinCloud PAYG)

Everything to do once you're logged into the cloud Mac. Copy/paste each block.
The meter is running — this is ordered to be fast.

## 1. Open Terminal
Spotlight (Cmd+Space) → type "Terminal" → Enter.

## 2. Get the code
```bash
cd ~
git clone https://github.com/<YOUR-USERNAME>/LittleBibleHelpers.git
cd LittleBibleHelpers
```
If the repo is **private**, the clone will ask for a username + password —
use your GitHub username and a Personal Access Token (not your login password)
as the password. Simplest alternative: make the repo Public just for this
session, then flip it back to Private afterward. The code has no secrets.

## 3. Generate the Xcode project
The `.xcodeproj` isn't in the repo — XcodeGen builds it from `project.yml`.

Try Homebrew first (works if this Mac has it):
```bash
brew install xcodegen && xcodegen generate
```

If that says `brew: command not found`, use the no-admin portable binary:
```bash
curl -L -o xcodegen.zip https://github.com/yonaskolb/XcodeGen/releases/latest/download/xcodegen.zip
unzip -o xcodegen.zip
./xcodegen/bin/xcodegen generate
```
(If `./xcodegen/bin/xcodegen` isn't found, run `unzip -l xcodegen.zip` to see
where the `xcodegen` binary landed, then run it from that path.)

You should see: `Created project at LittleBibleHelpers.xcodeproj`.

## 4. Open in Xcode
```bash
open LittleBibleHelpers.xcodeproj
```
Wait for Xcode to finish "Indexing" (top bar) before building.

## 5. Run in the iPad simulator
- Top toolbar, next to the ▶ button, click the device dropdown.
- Pick an **iPad** (e.g. "iPad Pro 11-inch" or "iPad (10th generation)").
  Do NOT pick an iPhone — this app is iPad-only.
- Press **▶** (or Cmd+R). First build takes a few minutes; simulator boot is slow.
- No Apple ID / developer account is needed for the simulator.

## 6. If it launches
- The app is **landscape-only**. If the simulator is portrait, rotate it:
  **Cmd+→** (or menu: Device → Rotate Left/Right).
- Try the flow: Home → Play → Noah's Ark → a game → celebration → sticker.

## 7. If you get build errors (expected on first build)
This code hasn't been compiled before, so a few red errors are normal.
Copy the error text (or screenshot the red banner) and send it to Claude in
the Windows chat. Don't try to fix Swift yourself — you'll get exact edits back,
push them, then `git pull` on the Mac and re-run.

## Loop for fixes
```bash
# on the Mac, after Claude pushes fixes from Windows:
git pull
# re-run in Xcode (Cmd+R)
```
