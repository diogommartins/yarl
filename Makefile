MD = $(shell python -c "import multidict; print(multidict.__path__[0])")

all: test


.install-deps: $(shell find requirements -type f)
	@pip install -U -r requirements/dev.txt
	@touch .install-deps


.develop: .install-deps $(shell find yarl -type f)
	@pip install -e .
	@touch .develop


test: .develop
	pytest ./tests ./yarl --flake8


vtest: .develop
	pytest ./tests ./yarl -v --flake8


cov: .develop
	pytest --cov yarl --cov-report html --cov-report term ./tests/ ./yarl/ --flake8
	@echo "open file://`pwd`/htmlcov/index.html"


doc: doctest
	make -C docs html SPHINXOPTS="-W -E"
	@echo "open file://`pwd`/docs/_build/html/index.html"


doctest: .develop
	make -C docs doctest


mypy:
	MYPYPATH=$(MD)/.. mypy yarl
	MYPYPATH=$(MD)/.. mypy --disallow-untyped-defs yarl/*.pyi
