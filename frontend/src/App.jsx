import { useCallback, useEffect, useMemo, useState } from "react";
import { api } from "./api";
import PersonForm from "./PersonForm.jsx";

export default function App() {
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(null);
  const [query, setQuery] = useState("");
  const [form, setForm] = useState(null); // null | { person: null | Personne }
  const [toDelete, setToDelete] = useState(null);
  const [toast, setToast] = useState(null);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      setRows(await api.list());
      setLoadError(null);
    } catch (e) {
      setLoadError(e.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    if (!toast) return;
    const t = setTimeout(() => setToast(null), 3500);
    return () => clearTimeout(t);
  }, [toast]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return rows;
    return rows.filter((p) => [p.code, p.name, p.cin].some((v) => v.toLowerCase().includes(q)));
  }, [rows, query]);

  const save = async (values) => {
    if (form.person) {
      await api.update(form.person.code, values);
      setToast("Modifications enregistrées");
    } else {
      await api.create(values);
      setToast("Personne ajoutée");
    }
    setForm(null);
    load();
  };

  const confirmDelete = async () => {
    try {
      await api.remove(toDelete.code);
      setToast("Personne supprimée");
    } catch (e) {
      setToast(e.message);
    }
    setToDelete(null);
    load();
  };

  return (
    <div className="page">
      <header className="topbar">
        <div>
          <h1>Gestion des Personnes avec Bassem & K8s & AWS & Iac</h1>
          <p className="muted">{rows.length} enregistrement{rows.length > 1 ? "s" : ""}</p>
        </div>
        <button className="btn primary" onClick={() => setForm({ person: null })}>Ajouter une personne</button>
      </header>

      <div className="toolbar">
        <input
          type="search"
          placeholder="Rechercher par code, nom ou CIN"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          aria-label="Rechercher"
        />
      </div>

      <div className="table-wrap">
        <table>
          <thead>
            <tr><th>Code</th><th>Nom</th><th>CIN</th><th className="right">Actions</th></tr>
          </thead>
          <tbody>
            {loading && <tr><td colSpan="4" className="state">Chargement…</td></tr>}
            {!loading && loadError && (
              <tr><td colSpan="4" className="state error">
                {loadError} <button className="link" onClick={load}>Réessayer</button>
              </td></tr>
            )}
            {!loading && !loadError && filtered.length === 0 && (
              <tr><td colSpan="4" className="state">
                {rows.length === 0 ? "Aucune personne pour le moment. Ajoutez la première." : "Aucun résultat pour cette recherche."}
              </td></tr>
            )}
            {!loading && !loadError && filtered.map((p) => (
              <tr key={p.code}>
                <td className="code">{p.code}</td>
                <td>{p.name}</td>
                <td className="code">{p.cin}</td>
                <td className="right">
                  <button className="btn small ghost" onClick={() => setForm({ person: p })}>Modifier</button>
                  <button className="btn small danger" onClick={() => setToDelete(p)}>Supprimer</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {form && <PersonForm person={form.person} onSubmit={save} onClose={() => setForm(null)} />}

      {toDelete && (
        <div className="overlay" onMouseDown={(e) => e.target === e.currentTarget && setToDelete(null)}>
          <div className="dialog" role="alertdialog" aria-modal="true">
            <h2>Supprimer cette personne ?</h2>
            <p>{toDelete.name} ({toDelete.code}) sera définitivement supprimé(e).</p>
            <div className="actions">
              <button className="btn ghost" onClick={() => setToDelete(null)}>Annuler</button>
              <button className="btn danger solid" onClick={confirmDelete}>Supprimer</button>
            </div>
          </div>
        </div>
      )}

      {toast && <div className="toast" role="status">{toast}</div>}
    </div>
  );
}
