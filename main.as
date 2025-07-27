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
    // Get race data and the local player
    auto RaceData = MLFeed::GetRaceData_V4();
    auto player = RaceData.GetPlayer_V4(MLFeed::LocalPlayersName);
    if (player is null) return;

    if (player.CpCount != lastCheckpoint) {
        lastCheckpoint = player.CpCount;

        int niceTime = IsANiceTime(player.LastCpTime);
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

