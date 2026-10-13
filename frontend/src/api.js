const BASE = "/api/personnes";

async function request(url, options) {
  let res;
  try {
    res = await fetch(url, {
      headers: { "Content-Type": "application/json" },
      ...options,
    });
  } catch {
    throw { message: "Serveur injoignable. Vérifiez que le backend est démarré.", fields: {} };
  }
  if (res.status === 204) return null;
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    throw { message: data.message || "Une erreur est survenue", fields: data.fields || {} };
  }
  return data;
}

export const api = {
  list: () => request(BASE),
  create: (p) => request(BASE, { method: "POST", body: JSON.stringify(p) }),
  update: (code, p) => request(`${BASE}/${encodeURIComponent(code)}`, { method: "PUT", body: JSON.stringify(p) }),
  remove: (code) => request(`${BASE}/${encodeURIComponent(code)}`, { method: "DELETE" }),
};
