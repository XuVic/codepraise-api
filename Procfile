release: rake db:migrate
web: rake worker:run:production && bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
