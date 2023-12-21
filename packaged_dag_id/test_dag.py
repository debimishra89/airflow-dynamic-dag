from dag_factory import DAGFactory
import datetime

# first task to run
script1=("extract",f"{PYTHONPATH} {PYTHON_ENV} -m scripts/script1")
script2=("transform","echo Hello2")
script3=("load","echo Hello3")


tasks = {}
# say_hi has no dependencies, set to []
tasks[script1] = []
# the other 2 tasks depend on say_hi
tasks[script2] = [script1]
tasks[script3] = [script1]

DAG_NAME = 'dag_factory_id8'

override_args = {
    'owner': 'Debi',
    'retries': 2
}

dag = DAGFactory().get_airflow_dag(DAG_NAME, tasks, default_args=override_args, cron='@daily')