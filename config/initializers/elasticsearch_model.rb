require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new log: true,
                                                        scheme: 'http',
                                                        host: 'localhost',
                                                        port: 9200,
                                                        user: ENV['ELASTICSEARCH_USER'],
                                                        password: ENV['ELASTICSEARCH_PASSWORD']
