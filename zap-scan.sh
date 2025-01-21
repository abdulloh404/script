from zapv2 import ZAPv2

zap = ZAPv2(apikey='your-api-key', proxies={'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080'})

target = 'https://example.com'
print(f'Scanning target: {target}')
scan_id = zap.spider.scan(target)

while int(zap.spider.status(scan_id)) < 100:
    print(f'Scan progress: {zap.spider.status(scan_id)}%')
    time.sleep(5)

print('Scan completed!')

alerts = zap.core.alerts(baseurl=target)
print(f'Alerts found: {len(alerts)}')
