



default[:nagios][:herald] = {
  :repo => 'https://github.com/etsy/nagios-herald.git',
  :gems => %w{ app_conf choice mail },
  :packages => %w{ python-dev libjpeg8 libjpeg8-dev libfreetype6 libfreetype6-dev zlib1g-dev },
  :cookbooks => %w{ python git },
  :pips => %w{ Pillow }
}
