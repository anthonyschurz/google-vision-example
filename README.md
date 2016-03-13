# google-vision-example
Use the Google Cloud Vision API to label images.

## Setup

```{bash}
# install the Google Cloud API client
$ bundle install
# run the ruby script
$ bundle exec
```

## Results

As of 2016-03-13, this will return the following results:

```
Example: chihuahua-muffin
  Dogs: 8 with dog labels
  Dogs: 0 with food labels
  Food: 1 with dog labels
  Food: 8 with food labels
Example: labradoodle-friedchicken
  Dogs: 8 with dog labels
  Dogs: 0 with food labels
  Food: 0 with dog labels
  Food: 8 with food labels
Example: puppy-bagel
  Dogs: 6 with dog labels
  Dogs: 3 with food labels
  Food: 0 with dog labels
  Food: 8 with food labels
```

## Image Credits

All images belong to [Karen Zack](https://twitter.com/teenybiscuit)

- [Labradoodle or Fried Chicken](https://twitter.com/teenybiscuit/status/705232709220769792)
- [Puppy or Bagel](https://twitter.com/teenybiscuit/status/707004279324696577)
- [Chihuahua or Muffin](https://twitter.com/teenybiscuit/status/707727863571582978)