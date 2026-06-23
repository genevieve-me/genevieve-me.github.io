+++
title = "Architecture Overview"
weight = 1
+++

## System Components

An event-driven architecture for air quality monitoring:

```
[BME280 Sensor] → [Raspberry Pi] → [Kafka] → [Telegraf] → [TimescaleDB] → [Grafana]
                                      ↓
                              [Schema Registry]
```

## Hardware

**Raspberry Pi** with **BME280** sensor measuring:
- Temperature
- Humidity
- Barometric pressure

## Software Stack

### Data Ingestion
- **Apache Kafka**: Event streaming platform for reliable data transport
- **Schema Registry**: Ensures data consistency with Avro/JSON schemas

### Data Processing
- **Telegraf**: Metrics collection agent, bridges Kafka to database

### Storage
- **TimescaleDB**: PostgreSQL extension optimized for time-series data

### Visualization
- **Grafana**: Dashboards for exploring trends over time

## Why Event Streaming?

Instead of direct writes to the database:
- **Decoupling**: Sensor can publish without knowing downstream consumers
- **Reliability**: Kafka provides durability and replay capability
- **Scalability**: Easy to add new consumers (alerts, analytics)
- **Learning**: Hands-on experience with modern data infrastructure

## Next Steps

- Set up Kafka cluster (or single-node for development)
- Define sensor data schema
- Configure Telegraf Kafka consumer
- Build initial Grafana dashboards
