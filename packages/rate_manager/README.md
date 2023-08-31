Delays function calls to match rate limits. E.g. a rate limit of 10 calls / second,
then 10 calls will take atleast one second.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

* Delay function calls matching multiple rate limits.
* Options for reserving function calls, such that it is always possible to make
a function call and not be delayed.

## Getting started

## Usage

```dart
RateLimit limit = RateLimit(3, 0, const Duration(seconds: 1));
final rateManger = RateManger([limit]);
rateManger.primaryCall(someFunction());
rateManger.primaryCall(someFunction());
rateManger.primaryCall(someFunction());
rateManger.primaryCall(someFunction());
```

## Additional information
