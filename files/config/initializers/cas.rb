CASSERVER = 'https://svc.msiu.ru/'
MSIUPORTAL = 'http://www.main.msiu.ru/'

require 'casclient'
require 'casclient/frameworks/rails/filter'

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => CASSERVER
)
