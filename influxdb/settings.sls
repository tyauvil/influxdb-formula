{% set p    = pillar.get('influxdb', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = grains.get('influxdb', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set influxdb = {} %}
{%- do influxdb.update({
  'version':             p.get('version', '1.2.1-1'),
  'uid':                 pc.get('uid', '5003'),
  'home_dir':            pc.get('home_dir', '/data/influxdb'),
  'graphite_db':         pc.get('graphite_db','graphite'),
  'graphite_ret_policy': pc.get('graphite_ret_policy','""'),
  'graphite_enabled':    pc.get('graphite_enabled', True ),
  }) %}
