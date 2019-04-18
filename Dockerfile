FROM ruby:2.5

WORKDIR /root

COPY Gemfile /root/Gemfile
COPY Gemfile.lock /root/Gemfile.lock
RUN bundle install
COPY transfert.rb /root/exe.rb

CMD ["ruby", "/root/exe.rb"]
