+++
title = "Air Quality Monitoring"
description = "Raspberry Pi-based air quality visualization using event streaming and time-series analysis"
sort_by = "weight"
template = "projects.html"
page_template = "projects-page.html"
+++

Building an end-to-end IoT data pipeline to monitor and visualize air quality in my apartment over time.

**Hardware:** Raspberry Pi with BME280 sensor (temperature, humidity, pressure)

**Architecture:** Event streaming approach using:
- Kafka + Schema Registry for data ingestion
- Telegraf for metrics collection
- TimescaleDB for time-series storage
- Grafana for visualization dashboards
