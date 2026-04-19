import os
import pymysql
from dotenv import load_dotenv
import logging

logger = logging.getLogger(__name__)

load_dotenv()

_pool = None


def _init_pool():
    global _pool
    if _pool is not None:
        return
    
    try:
        from dbutils.pooled_db import PooledDB
        
        _pool = PooledDB(
            creator=pymysql,
            maxconnections=10,         
            mincached=2,                
            maxcached=5,                
            blocking=True,
            ping=1,                     
            host=os.getenv('DB_HOST') or os.getenv('MYSQLHOST', 'localhost'),
            port=int(os.getenv('DB_PORT') or os.getenv('MYSQLPORT', 3306)),
            user=os.getenv('DB_USER') or os.getenv('MYSQLUSER', 'root'),
            password=os.getenv('DB_PASSWORD') or os.getenv('MYSQLPASSWORD', ''),
            database=os.getenv('DB_NAME') or os.getenv('MYSQLDATABASE', 'learnflow'),
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor,
        )
        logger.info('Database connection pool initialized')
    except ImportError:
        logger.warning('DBUtils not available, falling back to direct connections')
        _pool = None


def get_connection():
    _init_pool()
    
    if _pool is not None:
        try:
            return _pool.connection()
        except Exception as e:
            logger.error('Failed to get pooled connection: %s', str(e))
    
    return pymysql.connect(
        host=os.getenv('DB_HOST') or os.getenv('MYSQLHOST', 'localhost'),
        port=int(os.getenv('DB_PORT') or os.getenv('MYSQLPORT', 3306)),
        user=os.getenv('DB_USER') or os.getenv('MYSQLUSER', 'root'),
        password=os.getenv('DB_PASSWORD') or os.getenv('MYSQLPASSWORD', ''),
        database=os.getenv('DB_NAME') or os.getenv('MYSQLDATABASE', 'learnflow'),
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor,
    )

