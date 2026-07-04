from pyspark.sql import SparkSession
from pyspark.sql import Row

# Initialiser une session Spark
spark = SparkSession.builder.appName("SimpleDataFrame").getOrCreate()

# Créer des données sous forme de liste de dictionnaires
data = [
    Row(id=1, name="Alice", age=25),
    Row(id=2, name="Bob", age=30),
    Row(id=3, name="Charlie", age=35)
]

# Créer un DataFrame à partir des données
df = spark.createDataFrame(data)

# Afficher le DataFrame
df.show()

# Arrêter la session Spark
spark.stop()