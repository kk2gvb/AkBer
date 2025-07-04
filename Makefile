# Основная цель: собрать всё
all: deps erlang req

# Зависимости для сборки
deps: libzmq czmq rebar3 chumak

# Сборка libzmq из исходников
libzmq:
	cd deps/libzmq && ./autogen.sh && ./configure --prefix=$(PWD)/deps/libzmq/install --with-libsodium CFLAGS="-fPIC" && make && make install

# Сборка czmq из исходников
czmq:
	cd deps/czmq && ./autogen.sh && ./configure --prefix=$(PWD)/deps/czmq/install --with-libzmq=$(PWD)/deps/libzmq/install CFLAGS="-fPIC" && make && make install

# Сборка rebar3 из исходников
rebar3:
	cd tools/rebar3 && chmod +x bootstrap && ./bootstrap && chmod +x rebar3

# Сборка chumak (Erlang-библиотека)
chumak:
	test -f $(PWD)/tools/rebar3/rebar3 && cd deps/chumak && $(PWD)/tools/rebar3/rebar3 compile

# Сборка Erlang-приложения в rep
erlang:
	test -f $(PWD)/tools/rebar3/rebar3 && $(PWD)/tools/rebar3/rebar3 compile

# Сборка C-программы req
req:
	gcc -o req req.c -Ideps/czmq/install/include -Ideps/libzmq/install/include -Ldeps/czmq/install/lib -Ldeps/libzmq/install/lib -lzmq -lczmq -pthread

# Запуск C-программы req
run-req:
	LD_LIBRARY_PATH=$(PWD)/deps/libzmq/install/lib:$(PWD)/deps/czmq/install/lib ./req

# Запуск Erlang-приложения в rep
run-erlang:
	cd rep && ../tools/rebar3/rebar3 shell

# Очистка скомпилированных файлов
clean:
	rm -f req
	rm -rf rep/_build
	rm -rf deps/libzmq/install
	rm -rf deps/czmq/install
	rm -rf deps/chumak/_build
	rm -rf tools/rebar3/rebar3
