{%- from 'influxdb/settings.sls' import influxdb with context -%}

include:
  - telegraf

influxdb_group:
  group.present:
    - name: influxdb
    - gid: {{ influxdb.uid }}

influxdb_user:
  user.present:
    - name: influxdb
    - shell: /bin/false
    - home: {{ influxdb.home_dir }}
    - uid: {{ influxdb.uid }}
    - gid: {{ influxdb.uid }}

{% for dir in ['data','meta','wal'] %}
{{ influxdb.home_dir }}/{{ dir }}:
  file.directory:
    - makedirs: True
    - user: influxdb
    - group: influxdb
{% endfor %}

/etc/influxdb/influxdb.conf:
  file.managed:
    - makedirs: True
    - source: salt://influxdb/templates/influxdb.conf.toml
    - template: jinja
    - context:
        home_dir: {{ influxdb.home_dir }}
        {% if influxdb.graphite_enabled %}
        graphite_db: {{ influxdb.graphite_db }}
        graphite_db_ubic: {{ influxdb.graphite_db_ubic }}
        graphite_ret_policy: {{ influxdb.graphite_ret_policy }}
        {% endif %}
    - listen_in:
        - service: influxdb

influxdb:
  pkg.installed:
    - version: {{ influxdb.version }}
  service.running:
    - enable: True
    - require:
        -  pkgrepo: influxdata_repo
        -  file: /etc/influxdb/influxdb.conf
        -  user: influxdb
