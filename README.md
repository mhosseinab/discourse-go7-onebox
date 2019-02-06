# discourse-go7-onebox
This plugin for Discourse, extends Onebox to add support for embedding media from go7.ir (a Telegram file storage service) in Discourse posts.

## Demo

See it in action and test it out for yourself on [freepaper community](https://community.freepaper.me/?utm_source=github.com&utm_medium=readme&utm_term=demo&utm_content=discourse-aparat-onebox&utm_campaign=development).

## Installation

Add the plugin's repository URL to your container's `app.yml` file, for example:

```yml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - mkdir -p plugins
          - git clone https://github.com/mhosseinab/discourse-go7-onebox
```

Rebuild the container:

```
cd /var/discourse
./launcher rebuild app
```
### or

```
cd /var/discourse
./launcher enter app
rake plugin:install repo=https://github.com/mhosseinab/discourse-go7-onebox
rm -rf tmp/cache/*
sv restart unicorn
```

For the plugin to apply retroactively, you'll need to rebake old posts:

```
cd /var/discourse
./launcher enter app
rake posts:rebake
```

## License

The Discourse Plays.tv Onebox plugin is released under the [MIT License](LICENSE).
