# Define the Winlogbeat configuration for collecting only security logs
$winlogbeat_config = @"
###################### Winlogbeat Configuration Example ########################

# This file is an example configuration file highlighting only the most common
# options. The winlogbeat.reference.yml file from the same directory contains
# all the supported options with more comments. You can use it as a reference.
#
# You can find the full configuration reference here:
# https://www.elastic.co/guide/en/beats/winlogbeat/index.html

# ======================== Winlogbeat specific options =========================

# event_logs specifies a list of event logs to monitor as well as any
# accompanying options. The YAML data type of event_logs is a list of
# dictionaries.
#
# The supported keys are name, id, xml_query, tags, fields, fields_under_root,
# forwarded, ignore_older, level, event_id, provider, and include_xml.
# The xml_query key requires an id and must not be used with the name,
# ignore_older, level, event_id, or provider keys. Please visit the
# documentation for the complete details of each option.
# https://go.es.io/WinlogbeatConfig

winlogbeat.event_logs:
# - name: Application
#   ignore_older: 72h

# - name: System

  - name: Security
    ignore_older: 72h
# - name: Microsoft-Windows-Sysmon/Operational

# - name: Windows PowerShell
#   event_id: 400, 403, 600, 800

# - name: Microsoft-Windows-PowerShell/Operational
#   event_id: 4103, 4104, 4105, 4106

# - name: ForwardedEvents
#   tags: [forwarded]

# ====================== Elasticsearch template settings =======================

#setup.template.settings:
#  index.number_of_shards: 1
  #index.codec: best_compression
  #_source.enabled: false


# ================================== General ===================================

# The name of the shipper that publishes the network data. It can be used to group
# all the transactions sent by a single shipper in the web interface.
#name:

# The tags of the shipper are included in their own field with each
# transaction published.
#tags: ["service-X", "web-tier"]

# Optional fields that you can specify to add additional information to the
# output.
#fields:
#  env: staging

# ================================= Dashboards =================================
# These settings control loading the sample dashboards to the Kibana index. Loading
# the dashboards is disabled by default and can be enabled either by setting the
# options here or by using the setup command.
#setup.dashboards.enabled: false

# The URL from where to download the dashboards archive. By default this URL
# has a value which is computed based on the Beat name and version. For released
# versions, this URL points to the dashboard archive on the artifacts.elastic.co
# website.
#setup.dashboards.url:

# =================================== Kibana ===================================

# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# This requires a Kibana endpoint configuration.
#setup.kibana:

  # Kibana Host
  # Scheme and port can be left out and will be set to the default (http and 5601)
  # In case you specify and additional path, the scheme is required: http://localhost:5601/path
  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
  #host: "localhost:5601"

  # Kibana Space ID
  # ID of the Kibana Space into which the dashboards should be loaded. By default,
  # the Default Space will be used.
  #space.id:

# =============================== Elastic Cloud ================================

# These settings simplify using Winlogbeat with the Elastic Cloud (https://cloud.elastic.co/).

# The cloud.id setting overwrites the output.elasticsearch.hosts and
# setup.kibana.host options.
# You can find the cloud.id in the Elastic Cloud web UI.
#cloud.id:

# The cloud.auth setting overwrites the output.elasticsearch.username and
# output.elasticsearch.password settings. The format is <user>:<pass>.
#cloud.auth:

# ================================== Outputs ===================================

# Configure what output to use when sending the data collected by the beat.

# ---------------------------- Elasticsearch Output ----------------------------
#output.elasticsearch:
  # Array of hosts to connect to.
#  hosts: ["localhost:9200"]

  # Protocol - either http (default) or https.
  #protocol: "https"

  # Authentication credentials - either API key or username/password.
  #api_key: "id:api_key"
  #username: "elastic"
  #password: "changeme"

  # Pipeline to route events to security, sysmon, or powershell pipelines.
#  pipeline: "winlogbeat-%{[agent.version]}-routing"

# ------------------------------ Logstash Output -------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["192.168.224.179:5046"]

  # Optional SSL. By default is off.
  # List of root certificates for HTTPS server verifications
  #ssl.certificate_authorities: ["/etc/pki/root/ca.pem"]

  # Certificate for SSL client authentication
  #ssl.certificate: "/etc/pki/client/cert.pem"

  # Client Certificate Key
  #ssl.key: "/etc/pki/client/cert.key"

# ================================= Processors =================================
processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_tags:
      tags: [$env:computername, workstation, laptop]
 
# ================================== Logging ===================================

# Sets log level. The default log level is info.
# Available log levels are: error, warning, info, debug
#logging.level: debug

# At debug level, you can selectively enable logging only for some components.
# To enable all selectors use ["*"]. Examples of other selectors are "beat",
# "publisher", "service".
#logging.selectors: ["*"]

# ============================= X-Pack Monitoring ==============================
# Winlogbeat can export internal metrics to a central Elasticsearch monitoring
# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The
# reporting is disabled by default.

# Set to true to enable the monitoring reporter.
#monitoring.enabled: false

# Sets the UUID of the Elasticsearch cluster under which monitoring data for this
# Winlogbeat instance will appear in the Stack Monitoring UI. If output.elasticsearch
# is enabled, the UUID is derived from the Elasticsearch cluster referenced by output.elasticsearch.
#monitoring.cluster_uuid:

# Uncomment to send the metrics to Elasticsearch. Most settings from the
# Elasticsearch output are accepted here as well.
# Note that the settings should point to your Elasticsearch *monitoring* cluster.
# Any setting that is not set is automatically inherited from the Elasticsearch
# output configuration, so if you have the Elasticsearch output configured such
# that it is pointing to your Elasticsearch monitoring cluster, you can simply
# uncomment the following line.
#monitoring.elasticsearch:

# ============================== Instrumentation ===============================

# Instrumentation support for the winlogbeat.
#instrumentation:
    # Set to true to enable instrumentation of winlogbeat.
    #enabled: false

    # Environment in which winlogbeat is running on (eg: staging, production, etc.)
    #environment: ""

    # APM Server hosts to report instrumentation results to.
    #hosts:
    #  - http://localhost:8200

    # API Key for the APM Server(s).
    # If api_key is set then secret_token will be ignored.
    #api_key:

    # Secret token for the APM Server(s).
    #secret_token:


# ================================= Migration ==================================

# This allows to enable 6.7 migration aliases
#migration.6_to_7.enabled: true

 
"@
# Define the configuration file path
$winlogbeat_config_path = "C:\Program Files\Winlogbeat\winlogbeat-8.14.1-windows-x86_64\winlogbeat.yml"
# Define winlogbeat install path
$winlogbeat_install_path = "C:\Program Files\Winlogbeat"
# Define path to old winlogbeat version 
$oldwinlogbeat = Test-Path "C:\Program Files\Winlogbeat\winlogbeat-7.16.3-windows-x86_64"
# Define path to new winlogbeat version
$newwinlogbeat = Test-Path "C:\Program Files\Winlogbeat\winlogbeat-8.14.1-windows-x86_64"

IF ($oldwinlogbeat -eq $true) {
    get-process | where { $_.processname -eq 'winlogbeat' } | Stop-Process -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Winlogbeat\winlogbeat-7.16.3-windows-x86_64" -Recurse -force
$scriptPath = "C:\Program Files\Winlogbeat\winlogbeat-8.14.1-windows-x86_64\install-service-winlogbeat.ps1"  
Invoke-Expression -Command "& `"$scriptPath`""
Start-Service -Name winlogbeat

} ElseIF ($newwinlogbeat -eq $false) {
    Expand-Archive -Path "\\Fileshares\software\WinlogBeat\winlogbeat-8.14.1-windows-x86_64.zip" -DestinationPath "C:\Program Files\Winlogbeat"
    
   
# Write the configuration to the configuration file
Set-Content -Path $winlogbeat_config_path -Value $winlogbeat_config

# Create a Windows service for Winlogbeat
& "$winlogbeat_install_path\winlogbeat-8.14.1-windows-x86_64\install-service-winlogbeat.ps1"

# Start the Winlogbeat service
Start-Service winlogbeat
} ELSE {
    Write-Host "file not found"
    Set-Content -Path $winlogbeat_config_path -Value $winlogbeat_config
}

$serviceName = "winlogbeat" 
$service = Get-WmiObject Win32_Service | Where-Object {$_.Name -eq $serviceName}
$path = $service.PathName
Write-Host $path
