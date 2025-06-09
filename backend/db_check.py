import asyncpg
import asyncio

async def test_conn():
    conn = await asyncpg.connect("postgresql://postgres:1234@localhost:5432/digirakshak")
    print("Connected!")
    await conn.close()

asyncio.run(test_conn())
