#!/bin/bash

export $(cat .env | xargs)
npx supabase login --token $SUPABASE_ACCESS_TOKEN
npx supabase link --project-ref $SUPABASE_PROJECT_REF
npx supabase functions deploy finoclock --no-verify-jwt