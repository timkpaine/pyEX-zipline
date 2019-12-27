prebuild:  ## Copy assets from pyEX
	cp -r ../pyEX/pyEX/* ./pyEX/

tests: ## Clean and Make unit tests
	IEX_TOKEN=Tpk_ecc89ddf30a611e9958142010a80043c python3 -m pytest -v tests --cov=pyEX.zipline

test: lint ## run the tests for travis CI
	@ IEX_TOKEN=Tpk_ecc89ddf30a611e9958142010a80043c python3 -m pytest -v tests --cov=pyEX.zipline

lint: ## run linter
	flake8 pyEX/zipline 

fix:  ## run autopep8/tslint fix
	autopep8 --in-place -r -a -a pyEX/

annotate: ## MyPy type annotation check
	mypy -s pyEX/zipline

annotate_l: ## MyPy type annotation check - count only
	mypy -s pyEX/zipline | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info
	make -C ./docs clean
	rm -rf ./docs/*.*.rst  # generated
	rm -rf pyEX/*.py
	rm -rf pyEX/marketdata

docs:  ## make documentation
	make -C ./docs html
	open ./docs/_build/html/index.html

install:  ## install to site-packages
	pip3 install .

dist:  ## dist to pypi
	rm -rf dist build
	python3 setup.py sdist
	python3 setup.py bdist_wheel
	twine check dist/* && twine upload dist/*

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean test tests help annotate annotate_l docs dist
