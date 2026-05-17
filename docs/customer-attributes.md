# Customer Attributes And Profile Context

The Flutter SDK exposes the same attributes surface as the native iOS and
Android SDKs, but the backend stores different kinds of profile data on
different paths.

## Developer Custom Attributes

Use `setAttribute()`, `setAttributes()`, and `unsetAttribute()` for attributes
defined by the app developer:

```dart
await AppActor.instance.setAttributes({
  'plan': 'pro',
  'trial': true,
  'last_seen': AppActorAttributeValue.dateTime(DateTime.now()),
  'flags': const AppActorAttributeValue.boolList([true, false]),
});

await AppActor.instance.unsetAttribute('legacy_plan');
```

Custom attributes must use plain custom keys. Do not use `$`, `appactor.`, or
`integration.` prefixes here. `null` is rejected on custom writes so deletes stay
explicit through `unsetAttribute()`.

Supported custom values are strings, finite numbers, booleans, dates, and flat
string/number/boolean arrays. Date values are encoded as:

```json
{ "value": "2026-05-16T12:00:00.000Z", "valueType": "date" }
```

## Reserved Profile Helpers

Use the profile helper methods for AppActor-owned profile context:

```dart
await AppActor.instance.setEmail('user@example.com');
await AppActor.instance.setDisplayName('Ada Lovelace');
await AppActor.instance.setPhoneNumber('+15551234567');
await AppActor.instance.setPushToken('push-token');
await AppActor.instance.collectDeviceIdentifiers();
```

Passing `null` to the nullable profile helpers clears that reserved profile
field. `collectDeviceIdentifiers()` delegates to native iOS/Android so each
platform can send supported SDK/device context. The backend partitions hot
system fields such as platform, app version, SDK version, OS version, device
model, bundle/package ID, locale, timezone, and storefront country into
`profile_current`; they are not developer custom attributes.

## Integration Identifiers

Use integration identifier helpers for external user or device IDs:

```dart
await AppActor.instance.setAdjustID('adjust-user-123');
await AppActor.instance.setIntegrationIdentifier(
  AppActorIntegrationIdentifier.firebaseAppInstanceId,
  'firebase-instance-id',
);
await AppActor.instance.setCustomIntegrationIdentifier(
  'kochava_device_id',
  'device-123',
);
```

These values are routed to the integration identifier backend path, not the
custom attribute path.

## Attribution

Use attribution helpers for acquisition and campaign context:

```dart
await AppActor.instance.updateAttribution(
  AppActorAttribution(
    provider: AppActorAttributionProvider.adjust,
    status: AppActorAttributionStatus.nonOrganic,
    campaignName: 'spring_sale',
  ),
);

await AppActor.instance.setMediaSource('facebook');
await AppActor.instance.setCampaign('spring_sale');
```

Attribution helpers delegate to the native merge state so partial helper calls
stay aligned with iOS and Android.
