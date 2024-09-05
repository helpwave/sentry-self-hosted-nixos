## 1. Configuration und renaming:
```
.env.EXEMPLAR >rename> .env
sentry.conf.py.EXEMPLAR >rename> sentry.conf.py
```

## 2. Über prüfen ob alle dinste laufen:
```
systemctl status postgresql
systemctl status redis
systemctl status zookeeper
systemctl status kafka
systemctl status clickhouse
systemctl status sentry
systemctl status symbolicator
systemctl status snuba
systemctl status relay
```



