# Set Date Using NTP

**NTP** Network Time Protocol

You can update your server time using the NTPUpdate tool

```bash
sudo ntpdate time.nist.gov
```

The command above updates the machine to the time given my `time.nist.gov` server.

## Troubleshoot

### the NTP socket is in use, exiting

```bash
sudo ntpdate time.nist.gov
26 Aug 21:44:30 ntpdate[11377]: the NTP socket is in use, exiting
```
**Solution**
Stop the NTP Service

```bash
sudo service ntp stop
sudo ntpdate time.nist.gov
26 Aug 22:00:13 ntpdate[11395]: step time server 24.56.178.140 offset 893.947358 sec

```