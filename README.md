# ReminderBox
ReminderBox is a web application used to track reminders and send notifications. It needs to be self-hosted, I'm using a Raspberry Pi Zero W for this. When used in conjunction with IFTTT it can be used to send notifications to your phone to show your reminders at a set time every day. ReminderBox is still in quite early development, so it may seem a little rough at the moment. Also, please remember that you're self-hosting your own data on your own device, so good security is essential. Always use ReminderBox on your own password-protected local network.

## Todo
- Make the add form AJAX
- Make the description field in the add form a textarea, not an input
- Add an application manifest

## Future Features(?)
- Able to mark tasks as complete
- Cache page to view tasks when offline
- Adding tasks offline and syncing them when online

## Known Issues
The Gemfile might be outdated, as my Pi Zero can't install the `thin` gem for some reason, so I may have neglected the Gemfile.

## Installation Guide
To use ReminderBox, I reccommend a Raspberry Pi Zero, or similar device running Linux. In my case I have Raspberry Pi OS Lite. The easiest way to interact with the Pi Zero is to install your operating system and then enable key-authenticated SSH to allow you to use the Pi on a different device.

Once your device is set up, install Git and clone this repository. You will then need to install Ruby and Sqlite3.

You'll also need to know the local IP address of the device you're using to run ReminderBox. On Linux you can do this by typing `ifconfig` in the terminal. You're looking for an IP address that follows the pattern `192.168.X.X`.

After installing dependencies, you should be able to start the server by doing:
`cd ReminderBox/`
`ruby app.rb -o 0.0.0.0`
From here, you should be able to use ReminderBox by going to `http://[YOUR-IP]:4567` on any device connected to the same network as the server.

## IFTTT and Crontabs
If you want ReminderBox to send you automatic reminders, the best thing to do is to set up an IFTTT recipe. Cron jobs can be used to aid automation of sending notifications. Below is a tutorial on how to set it up.

### IFTTT Recipe
This IFTTT recipe will let the server send a notification to your phone through the IFTTT app

- To set up an IFTTT recipe, first make a free account at [ifttt.com](https://ifttt.com)
- Once logged in, click `Create` in the top right
- Press the `Add` button next to `If That`
- Use the search bar to select Webhooks from the list of services
- Select `Receive a web request` on the next screen, then give the event a name (anything will do, but you'll need it later)
- Press the `Add` button next to `Then This`
- Use the search bar to select Notifications from the list of services
- Select `Send a rich notification from the IFTTT app` on the next screen
- Now we need to define what the notification will say:
    - Title: `ReminderBox`
    - Message: Use the `Add Ingredient` button to make the message say `You have {{Value1}} reminders for this {{Value2}}`
    - Link URL: `{{Value3}}`
- Click `Create Action`, then `Continue`, then `Finish`
- Download the IFTTT app onto your phone
- Find your Webhooks API key by going to [this page](https://ifttt.com/maker_webhooks) and then clicking `Documentation`
- On your server device, type `nano ~/.profile`
- Create some environment variables the server needs to contact IFTTT. Make sure you NEVER share your key with anyone. Past these lines into your `.profile` file
    - `export IFTTTEVENT="[NAME OF EVENT]"` where the name of the event is the same name you entered earlier
    - `export IFTTTKEY="[KEY]"` where your key is on the Documentation page linked above
- Restart your server device for the new environment variables to load

### Cron Jobs
Setting up cron jobs allows your server device to automatically send out notifications at the same times every day.
To create new cron jobs on your server device, enter `crontab -e` and select your preferred editor. Once you can see the file, scroll down until you reach the end and enter the following:

- `0 8 * * 1-5 curl http://localhost:4567/cron/AM` sends a notification every weekday morning at 8 AM
- `0 10 * * 6-7 curl http://localhost:4567/cron/AM` sends a notification every weekend morning at 10 AM
- `15 18 * * * curl http://localhost:4567/cron/PM` sends a notification every evening at 6:15 PM

Obviously these cron jobs can be changed to suit your own needs. For help making your own, use [Crontab.guru](https://crontab.guru/).
