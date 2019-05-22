IMAGE_NAME ?= image://adavydow/hs_course
COURSE_FOLDER ?= storage://adavydow/hs_course
NOTEBOOK_FOLDER ?= storage:course/notebooks
RESULT_FOLDER ?= storage:coure/results
CPU ?= 5
GPU ?= 1
MEMORY ?= 20G
LESSON ?= lesson1

.PHONY: setup
setup:
	pip install neuromation
	neuro login

.PHONY: purge
purge:
	neuro rm $(NOTEBOOK_FOLDER)/$(LESSON)/notebook.ipynb

.PHONY: run
run:
	neuro job submit $(IMAGE_NAME) --volume $(COURSE_FOLDER)/$(LESSON):/notebooks:ro \
          --volume $(NOTEBOOK_FOLDER)/$(LESSON):/my_notebooks:rw \
          --volume $(RESULT_FOLDER)/$(LESSON):/results:rw \
          --gpu $(GPU) \
          --cpu $(CPU) \
          --memory $(MEMORY) \
          --http 8888 \
          --name cv-$(LESSON) \
          jupyter

.PHONY: tensorboard
tensorboard:
	neuro submit --volume $(RESULT_FOLDER)/$(LESSON):/result:rw \
	             --http 6006 \
	             tensorflow/tensorflow \
	             --name tensorboard-$(LESSON) \
	             'tensorboard --logdir=/result'
