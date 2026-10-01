from app import app


def test_menu_has_five_items():
    response = app.test_client().get("/menu")

    assert response.status_code == 200
    assert len(response.get_json()) == 5


def test_health_and_version(monkeypatch):
    monkeypatch.setenv("APP_VERSION", "test-release")
    client = app.test_client()

    assert client.get("/health").get_json() == {"status": "ok"}
    assert client.get("/version").get_json() == {"version": "test-release"}
