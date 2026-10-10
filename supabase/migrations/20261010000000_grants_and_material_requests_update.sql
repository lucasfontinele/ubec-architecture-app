-- Projetos Supabase novos não expõem tabelas do schema public na Data API por padrão
-- (https://supabase.com/changelog/45329-breaking-change-tables-not-exposed-to-data-and-graphql-api-automatically).
-- O RLS continua valendo: todas as tabelas têm RLS ligado e as policies decidem o acesso real.
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated, service_role;

-- O dono do material aprova/recusa o frete (materials.$id.tsx: updateFreightStatus).
-- Sem policy de UPDATE o RLS ignora o update em silêncio (0 linhas, sem erro).
CREATE POLICY "Material owner updates material requests" ON public.material_requests
  FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.materials m WHERE m.id = material_id AND m.owner_id = auth.uid()));
