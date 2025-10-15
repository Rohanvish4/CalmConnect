# Logo Assets

Place your custom CalmConnect logo files here:

## Recommended formats and sizes:
- **logo.png** - Main logo (recommended size: 512x512px)
- **logo_white.png** - White version for dark backgrounds
- **logo_small.png** - Small version (64x64px) for navigation or small displays

## Supported formats:
- PNG (recommended for logos with transparency)
- JPG/JPEG (for photos)
- SVG (not natively supported, convert to PNG)

## Usage:
Once you place your logo file (e.g., logo.png), it will be accessible in the app via:
```dart
Image.asset('assets/images/logo.png')
```

## Current Implementation:
The app currently uses a psychology icon as placeholder. Your custom logo will replace this in:
- Authentication/Login screen
- App header (if applicable)
- Splash screen (if implemented)