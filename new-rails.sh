RUBY_VERSION="2.3.4"
NAME=$1

GEMSET="${RUBY_VERSION}@${NAME}"

echo "Creating gemset $GEMSET"


source ~/.rvm/scripts/rvm
rvm use --create $GEMSET

gem install rails

rails new $NAME --skip-bundle

cd $NAME
rvm --rvmrc $GEMSET

cd ..; cd -
