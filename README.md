Setting up env
-----------

```
cp config/database.yml.sample config/database.yml
cp config/secrets.yml.sample config/secrets.yml
bundle install
rake db:create
rake db:migrate
```

Campaign id that was tested: 2140783

API
-------------
- /api/v1/reports.json
- /api/v1/reports/:ID.json
