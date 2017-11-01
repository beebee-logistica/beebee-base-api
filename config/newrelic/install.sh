# New Relic config
mkdir /opt
cd /opt

# Download newrelic-agent
NEWRELIC_VERSION="${NEWRELIC_VERSION:-7.6.0.201}"
wget http://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz

# Decompress newrelic-agent
gzip -dc newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz | tar xf -

# Install New Relic
./newrelic-php5-${NEWRELIC_VERSION}-linux-musl/newrelic-install install
