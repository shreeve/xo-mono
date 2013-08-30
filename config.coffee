exports.config =
  # See http://brunch.io/#documentation for docs.
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app)/
      order:
        after: [
          'test/vendor/scripts/test-helper.js'
        ]

    stylesheets:
      joinTo: 'stylesheets/app.css'
      order:
        after: ['vendor/helpers.css']

    templates:
      joinTo: 'javascripts/app.js'
