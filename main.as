//
// Settings
//

[Setting category="Check for a nice time" name="Enabled" description="Check for a nice time"]
bool enabled = true;
[Setting category="Check for a nice time" name="Checkpoints" description="Enable nice time check when passing checkpoints"]
bool niceOnCheckpoint = true;
[Setting category="Check for a nice time" name="Finish" description="Enable nice time check when passing finish"]
bool niceOnFinish = true;
[Setting category="Check for a nice time" name="Test mode" description="Every time is a nice time, for testing purposes"]
bool testMode = false;

[SettingsTab name="Try me" icon="Play"]
void RenderSettings()
{
    if (UI::Button("Nice!")) {
        Audio::Play(niceSample);
    }
}

//
// End of settings
//

//
// Menu
//

void RenderMenu()
{
    string clr = "\\$0f0";
    if (!enabled) {
        clr = "\\$f00";
    };
    if (UI::MenuItem(clr + Icons::Flag + "\\$z Nice!", "", enabled)) {
            enabled = !enabled;
            if (enabled) {
                Audio::Play(niceSample);
            }
    }
}

//
// End of menu
//

Audio::Sample@ niceSample = null;
Audio::Sample@ snoopSample = null;
Audio::Sample@ knockSample = null;

int lastCheckpoint = -1;

void Main() 
{
    @niceSample = Audio::LoadSample("assets/nice.wav");
    @snoopSample = Audio::LoadSample("assets/snoop.wav");
    @knockSample = Audio::LoadSample("assets/knock.wav");
}

void Update(float dt) {
    if (GetApp().CurrentPlayground is null) return;

    // Only check for nice times if enabled and at least one of the options is enabled
    if (!enabled || (!niceOnCheckpoint && !niceOnFinish)) {
        return;
    }

    // Get race data and the local player
    auto RaceData = MLFeed::GetRaceData_V4();
    auto player = RaceData.GetPlayer_V4(MLFeed::LocalPlayersName);
    if (player is null) return;

    if (player.CpCount != lastCheckpoint) {
        lastCheckpoint = player.CpCount;
        if (lastCheckpoint == 0) return;
        if ((player.IsFinished && niceOnFinish) || (!player.IsFinished && niceOnCheckpoint)) {
            int niceTime = IsANiceTime(player.LastCpTime);
            if (testMode) {
                niceTime = 1;
            }
            if (niceTime == 3) {
                // both nice as 420? For now play nice until we have a better sound
                Audio::Play(niceSample);
            }
            if (niceTime == 2) {
                Audio::Play(snoopSample);
            }
            if (niceTime == 1) {
                Audio::Play(niceSample);
            }
            if (niceTime == 0) {
                // celebrate my AT in life
                if (player.LastCpTime % 10000 == 1906) {
                    Audio::Play(knockSample);
                }
            }
        }
    }
}

int IsANiceTime(int cpTime) {
    // Check if the checkpoint time is a "nice" time
    int ret = 0;
    if (
        (cpTime % 100 == 69)
        || (cpTime >= 69000 && cpTime < 70000)
        || (cpTime % 1000 >= 690 && cpTime % 1000 < 700)
    ) {
        ret = ret + 1;
    }

    if (
        (cpTime % 1000 == 420)
        || (cpTime >= 420000 && cpTime < 421000)
    ) {
        ret = ret + 2;
    }

    return ret;
}

