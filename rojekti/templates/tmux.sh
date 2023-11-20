#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipeset -e

if [ -z ${DEBUG+x} ]; then
  set -x
fi

tmux start-server

cd {{ root }}

# Run project on start hooks
# TODO(tatu): I've yet to use this

if tmux has-session -t "{{ name }}" &>/dev/null; then
  # TODO(tatu): Implement existing session support
  echo "existing session"
else
{% for window in windows -%}
  {% if loop.index == 1 -%}
  # XXX(tatu): Why do we reset TMUX?
  # XXX(tatu): Why does indentation get fucked here by extra level
  TMUX= tmux new-session -d -s {{ name }} -n {{ window.name }}
  tmux send-keys -t {{ name }}:{{ loop.index }} cd\ {{ root }} C-m
  {% else -%}
    tmux new-window -c {{ root }} -t {{ name }}:{{ loop.index }} -n {{ window.name }}
  {% endif -%}
  {% if window.command -%}
    tmux send-keys -t {{ name }}:{{ loop.index }} {{ window.command }} C-m
  {% endif -%}
{% endfor %}
fi

{% if attach  -%}
if [ -z "$TMUX" ]; then
  tmux -u attach-session -t {{ name }}
else
  tmux -u switch-client -t {{ name }}
fi
{% endif -%}

