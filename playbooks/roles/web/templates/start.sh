#!/bin/bash
/home/app/.local/bin/gunicorn -b :8080 catsordogs:app