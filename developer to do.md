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

## 3. Datenbank Initialisieren:
```
sentry upgrade
```

## 4. Superuser erstellen:
```
sentry createuser --email you@example.com --superuser
```

## 5. Sentry-Dienste manuel starten:
```
systemctl start sentry-web
systemctl start sentry-worker
systemctl start sentry-cron
systemctl start sentry-relay
```
logs überprüfen:
```
journalctl -u sentry-web
journalctl -u sentry-worker
```

## 6. Relay Konfiguration:
```
systemctl status sentry-relay
```

## 9. Firewall-Regeln
```
sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
```

## 10. Überwachen der Dienste
```
journalctl -u sentry-web -f
journalctl -u sentry-worker -f
```