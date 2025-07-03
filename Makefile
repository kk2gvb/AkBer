all: deps erlang req

deps: libzmq czmq chumak rebar3

libzmq:
	cd deps/libzmq && ./autogen.sh && ./configure --prefix=$(PWD)/deps/libzmq/install --with-libsodium CFLAGS="-fPIC" && make && make install

czmq:
	cd deps/czmq && ./autogen.sh && ./configure --prefix=$(PWD)/deps/czmq/install --with-libzmq=$(PWD)/deps/libzmq/install CFLAGS="-fPIC" && make && make install

chumak:
	cd deps/chumak && $(PWD)/tools/rebar3 compile

rebar3:
	cd tools/rebar3 && ./bootstrap

erlang:
	./tools/rebar3 compile

req:
	gcc -o req req.c -Ideps/czmq/install/include -Ideps/libzmq/install/include -Ldeps/czmq/install/lib -Ldeps/libzmq/install/lib -lczmq -lzmq

clean:
	rm -f req
	rm -rf rep/_build
	rm -rf deps/libzmq/install
	rm -rf deps/czmq/install
	rm -rf deps/chumak/_build
	rm -rf tools/rebar3/rebar3
