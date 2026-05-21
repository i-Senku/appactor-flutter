const Set<String> legacyProfileCurrentAliases = {
  'appVersion',
  'appBuild',
  'sdkVersion',
  'platform',
  'platformFlavor',
  'platformVersion',
  'osVersion',
  'deviceModel',
  'bundleId',
  'locale',
  'timezone',
  'storefrontCountry',
  'ipCountry',
  'localeCountry',
  'attConsentStatus',
  'deviceLocale',
  'userCountry',
  'userCountrySource',
};

bool isLegacyProfileCurrentAlias(String key) =>
    legacyProfileCurrentAliases.contains(key);
