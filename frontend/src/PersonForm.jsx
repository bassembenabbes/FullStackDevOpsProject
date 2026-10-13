import { useEffect, useRef, useState } from "react";

export default function PersonForm({ person, onSubmit, onClose }) {
  const editing = Boolean(person);
  const [values, setValues] = useState(person ?? { code: "", name: "", cin: "" });
  const [errors, setErrors] = useState({});
  const [saving, setSaving] = useState(false);
  const first = useRef(null);

  useEffect(() => {
    first.current?.focus();
    const onKey = (e) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  const change = (e) => {
    const { name, value } = e.target;
    setValues((v) => ({ ...v, [name]: name === "cin" ? value.replace(/\D/g, "").slice(0, 8) : value }));
    setErrors((er) => ({ ...er, [name]: undefined }));
  };

  const validate = () => {
    const er = {};
    if (!values.code.trim()) er.code = "Le code est obligatoire";
    if (!values.name.trim()) er.name = "Le nom est obligatoire";
    if (!/^\d{8}$/.test(values.cin)) er.cin = "Le CIN doit contenir 8 chiffres";
    return er;
  };

  const submit = async (e) => {
    e.preventDefault();
    const er = validate();
    setErrors(er);
    if (Object.keys(er).length) return;
    setSaving(true);
    try {
      await onSubmit(values);
    } catch (err) {
      setErrors(Object.keys(err.fields).length ? err.fields : { form: err.message });
      setSaving(false);
    }
  };

  return (
    <div className="overlay" onMouseDown={(e) => e.target === e.currentTarget && onClose()}>
      <form className="dialog" role="dialog" aria-modal="true" aria-labelledby="form-title" onSubmit={submit} noValidate>
        <h2 id="form-title">{editing ? "Modifier la personne" : "Ajouter une personne"}</h2>

        <label>
          Code
          <input ref={first} name="code" value={values.code} onChange={change} disabled={editing} maxLength={20} />
          {errors.code && <span className="error">{errors.code}</span>}
        </label>
        <label>
          Nom complet
          <input name="name" value={values.name} onChange={change} maxLength={100} />
          {errors.name && <span className="error">{errors.name}</span>}
        </label>
        <label>
          CIN
          <input name="cin" value={values.cin} onChange={change} inputMode="numeric" placeholder="8 chiffres" />
          {errors.cin && <span className="error">{errors.cin}</span>}
        </label>

        {errors.form && <p className="error banner">{errors.form}</p>}

        <div className="actions">
          <button type="button" className="btn ghost" onClick={onClose}>Annuler</button>
          <button type="submit" className="btn primary" disabled={saving}>
            {saving ? "Enregistrement…" : editing ? "Enregistrer les modifications" : "Ajouter"}
          </button>
        </div>
      </form>
    </div>
  );
}
