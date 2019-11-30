tests: ## Clean and Make unit tests
	python3 -m pytest -v tests --cov=pyEXzipline

test: lint ## run the tests for travis CI
	@ python3 -m pytest -v tests --cov=pyEXzipline

lint: ## run linter
	flake8 pyEXzipline 

fix:  ## run autopep8/tslint fix
	autopep8 --in-place -r -a -a pyEX/

annotate: ## MyPy type annotation check
	mypy -s pyEXzipline

annotate_l: ## MyPy type annotation check - count only
	mypy -s pyEXzipline | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info
	make -C ./docs clean

docs:  ## make documentation
	make -C ./docs html

install:  ## install to site-packages
	pip3 install .

dist:  ## dist to pypi
	python3 setup.py sdist upload -r pypi

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean test tests help annotate annotate_l docs dist
