SecureNet = {}

SecureNet.Carwhitelist = {
    "esx_garage", -- add here scripts that can spawn cars for example esx_garage
}

SecureNet.Dicts = {
    "HydroMenu", -- etc.
}

SecureNet.Functions = {
    "vrpdestroy",
    "Oscillate",
    "forcetick",
    "ApplyShockwave",
    "GetCoordsInfrontOfEntityWithDistance",
    "TeleporterinoPlayer",
    "Clean2"
  }

SecureNet.AntiTextEntries = {
    "FMMC_KEY_TIP1",
    "TITLETEXT",
    "FMMC_KEY_TIP1_MISC",
}

SecureNet.MenuFunctions = { 
    {'TriggerCustomEvent', 'Hoax'}, {'GetResources', 'SkidMenu'}, {'ShootPlayer', 'Lynx'},
}

SecureNet.MenuTables = {
    {'Dopamine', 'Dopamine'}, {'LuxUI', 'Lux'}, {'objs_tospawn', 'SkidMenu'},
}

SecureNet.ClientEvents = {
    'esx_society:openBossMenu',
    'esx_ambulancejob:revive',
    'esx-qalle-jail:openJailMenu',
    'HCheat:TempDisableDetection',
}

SecureNet.config = {
    AnticlearPedTasksEvent = true,
    AntiremoveWeaponEvent = true,
    AntigiveWeaponEvent = true,
    AntiEvents = true,
    AntiSpam = true,
    AntiParticles = true,
}