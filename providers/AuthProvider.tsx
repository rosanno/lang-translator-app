import { supabase } from "@/utils/supabase";
import { Session } from "@supabase/supabase-js";
import { PropsWithChildren, useState } from "react";

export default function AuthProvider({ children }: PropsWithChildren) {
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);

  const premiumExpriresAt: string | null = profile?.premium_expires_at ?? null;
  const isPremium =
    !!profile?.is_premium &&
    (!premiumExpriresAt || new Date(premiumExpriresAt) > new Date());

  const loadProfile = async (s: Session | null) => {
    if (!s) {
      setProfile(null);
      return;
    }

    const { error, data } = await supabase
      .from("profiles")
      .select("*")
      .eq("id", s.user.id)
      .maybeSingle();

    setProfile(error ? null : data);
  };

  const refreshProfile = () => loadProfile(session);
}
