from flask import Flask, request, render_template_string, redirect
import boto3, os, uuid

app = Flask(__name__)
ddb = boto3.resource("dynamodb")
TABLE = os.environ.get("TABLE", "todo")

HTML = """
<!doctype html><title>Todo List</title>
<h1>My Tasks</h1>
<form action="/add" method="post">
  <input name="task" placeholder="New task">
  <input type="submit" value="Add">
</form>
<ul>
{% for t in tasks %}
  <li>{{t['id'][:8]}} - {{t['task']}}
      <a href="/delete/{{t['id']}}">❌</a></li>
{% endfor %}
</ul>
"""

@app.route("/")
def index():
    table = ddb.Table(TABLE)
    items = table.scan().get("Items", [])
    return render_template_string(HTML, tasks=items)

@app.post("/add")
def add():
    t = request.form["task"]
    table = ddb.Table(TABLE)
    table.put_item(Item={"id": str(uuid.uuid4()), "task": t})
    return redirect("/")

@app.route("/delete/<id>")
def delete(id):
    ddb.Table(TABLE).delete_item(Key={"id": id})
    return redirect("/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
