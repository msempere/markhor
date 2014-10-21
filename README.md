Markhor [![Build Status](https://travis-ci.org/msempere/markhor.svg?branch=master)](https://travis-ci.org/msempere/markhor)
=======

OpenRTB server in Erlang


Usage
-----

Running the app starts the server on port 5544 by default. It could be changed in **src/markhor.app.src**:

    {env, [{http_port, 5544}]}


Once the server is running, you have to create bidding agents, stored in **priv** folder.
A bidding agent looks like the following:

    # basic.yaml

    name:       basic
    bid_price:  0.1
    iurl:       http://localhots/preview/

    creatives:
        -   id:         0
            width:      300
            height:     250
            adid:       basic_agent_300x250
            adomain:    basic_agent.com
            nurl:       http://localhost/creatives/basic_agent/300x250?winPrice=${AUCTION_PRICE}

        -   id:         1
            width:      90
            height:     90
            format:     90x90
            adid:       basic_agent_90x90
            adomain:    basic_agent.com
            nurl:       http://localhost/creatives/basic_agent/90x90?winPrice=${AUCTION_PRICE}



And you can send a petition to the server for starting that agent:

    curl -i  http://localhost:5544/agent/basic -X GET


If everything is ok, you have an agent ready for bidding, now. And you can add as many agents as you want to compete to each other for a bid request.

The following command send a test bid request (stored in **test/example.json** to the server:

    curl -i  http://localhost:5544/ -X POST -H "Content-Type: application/json" -d @./test/example.json
