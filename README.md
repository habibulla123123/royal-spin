# Royal Spin — phone APK build

This project is a Flutter virtual-coins demo.

## Build an APK from a phone
1. Create/sign in to a GitHub account.
2. Create a new repository, for example `royal-spin`.
3. Upload all files from this project ZIP to the repository.
4. Open the **Actions** tab.
5. Select **Build Royal Spin APK**.
6. Tap **Run workflow**.
7. When the workflow finishes, open the completed run and download the artifact named **royal-spin-apk**.
8. Extract the artifact and install `app-release.apk` on your Android phone.

The workflow creates the missing Android platform files automatically, so Android Studio is not required for this build route.

This demo uses virtual coins only. It does not implement real-money deposits, withdrawals, or betting.
